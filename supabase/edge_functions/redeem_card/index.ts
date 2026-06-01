import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  try {
    const { code } = await req.json()
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? ""
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    const supabase = createClient(supabaseUrl, supabaseKey)
    const authHeader = req.headers.get("Authorization")!
    const token = authHeader.replace("Bearer ", "")
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 })
    }
    const { data: card, error: cardError } = await supabase
      .from("recharge_cards")
      .select("*")
      .eq("code", code)
      .eq("is_redeemed", false)
      .single()
    if (cardError || !card) {
      return new Response(JSON.stringify({ error: "Invalid or already redeemed card" }), { status: 400 })
    }
    await supabase.from("recharge_cards").update({ is_redeemed: true, redeemed_by: user.id }).eq("id", card.id)
    const { data: player } = await supabase.from("players").select("ori_coin").eq("id", user.id).single()
    const newBalance = player.ori_coin + card.ori_coin_value
    await supabase.from("players").update({ ori_coin: newBalance }).eq("id", user.id)
    await supabase.from("transactions").insert({
      player_id: user.id, type: "RECHARGE", amount: card.value, ori_coin_amount: card.ori_coin_value, status: "COMPLETED"
    })
    return new Response(JSON.stringify({ success: true, ori_coin_added: card.ori_coin_value, new_balance: newBalance }), { status: 200 })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})