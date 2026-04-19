Consumer ID
594c1f43-ae0f-4c0c-9388-316f66069d53
model:Pathumma-ThaiLLM-qwen3-8b-think-3.0.0

How to Use
Use this API key to make requests to the ThaiLLM API:

curl http://thaillm.or.th/api/pathumma/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "apikey: t3ox************************RN3O" \
  -d '{
    "model": "/model",
    "messages": [
      {"role": "user", "content": "สวัสดี"}
    ],
    "max_tokens": 2048,
    "temperature": 0.3
  }'
Rate Limits
5 requests per second
200 requests per minute