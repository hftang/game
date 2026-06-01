import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? ""
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    const supabase = createClient(supabaseUrl, supabaseKey)
    const authHeader = req.headers.get("Authorization")!
    const token = authHeader.replace("Bearer ", "")
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 })
    }
    const { data: monthlyCard } = await supabase
      .from("monthly_cards")
      .select("*")
      .eq("player_id", user.id)
      .gt("end_date", new Date().toISOString())
      .single()
    if (!monthlyCard) {
      return new Response(JSON.stringify({ error: "No active monthly card" }), { status: 400 })
    }
    const today = new Date().toISOString().split("T")[0]
    if (monthlyCard.last_claim_date === today) {
      return new Response(JSON.stringify({ error: "Already claimed today" }), { status: 400 })
    }
    const { data: player } = await supabase.from("players").select("ori_coin").eq("id", user.id).single()
    const newBalance = player.ori_coin + 50
    await supabase.from("players").update({ ori_coin: newBalance }).eq("id", user.id)
    await supabase.from("monthly_cards").update({ last_claim_date: today }).eq("id", monthlyCard.id)
    return new Response(JSON.stringify({ success: true, reward: 50, new_balance: newBalance }), { status: 200 })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})