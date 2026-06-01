extends Node

signal login_success(player_data: Dictionary)
signal login_failed(error: String)
signal api_error(error: String)

const SUPABASE_URL = "https://your-project.supabase.co"
const SUPABASE_ANON_KEY = "your-anon-key"

var http_request: HTTPRequest
var auth_token: String = ""

func _ready():
  http_request = HTTPRequest.new()
  add_child(http_request)
  http_request.request_completed.connect(_on_request_completed)

func register(email: String, password: String, username: String) -> void:
  var url = SUPABASE_URL + "/auth/v1/signup"
  var headers = ["Content-Type: application/json", "apikey: " + SUPABASE_ANON_KEY]
  var body = JSON.stringify({"email": email, "password": password, "data": {"username": username}})
  http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func login(email: String, password: String) -> void:
  var url = SUPABASE_URL + "/auth/v1/token?grant_type=password"
  var headers = ["Content-Type: application/json", "apikey: " + SUPABASE_ANON_KEY]
  var body = JSON.stringify({"email": email, "password": password})
  http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
  var json = JSON.new()
  var error = json.parse(body.get_string_from_utf8())
  if error != OK:
    api_error.emit("Failed to parse response")
    return
  var data = json.data
  if response_code >= 200 and response_code < 300:
    if data.has("access_token"):
      auth_token = data["access_token"]
    login_success.emit(data)
  else:
    var error_msg = data.get("error_description", data.get("message", "Unknown error"))
    login_failed.emit(error_msg)

func _get_auth_headers() -> Array:
  return ["Content-Type: application/json", "apikey: " + SUPABASE_ANON_KEY, "Authorization: Bearer " + auth_token]

func save_character(character_data: Dictionary) -> void:
  var url = SUPABASE_URL + "/rest/v1/characters"
  var body = JSON.stringify(character_data)
  http_request.request(url, _get_auth_headers(), HTTPClient.METHOD_POST, body)

func load_characters(player_id: String) -> void:
  var url = SUPABASE_URL + "/rest/v1/characters?player_id=eq." + player_id
  http_request.request(url, _get_auth_headers(), HTTPClient.METHOD_GET)

func redeem_card(code: String) -> void:
  var url = SUPABASE_URL + "/functions/v1/redeem_card"
  var body = JSON.stringify({"code": code})
  http_request.request(url, _get_auth_headers(), HTTPClient.METHOD_POST, body)