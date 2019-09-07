
data "aws_kms_secrets" "secrets" {
  secret {
    name    = "github_token"
    payload = "AQICAHhKdRavF8B7wWI/ZeHt2cEulfcUu9tExhGy3vMmcTir7QFzLeT2jmIpXfyx+Z/UWsPiAAAAiTCBhgYJKoZIhvcNAQcGoHkwdwIBADByBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDJWPm/8cczRSk7myPQIBEIBFGd5G041h1qO4LiQ6oSzuOoDUTn8AkUu81Hv3RQY9mXQ/jPz69y8seH030AlrYxg6UOW/mcJN7zVkdPrsBI2ZsczCUNz0"
  }

  secret {
    name    = "webhook_secret"
    payload = "AQICAHhKdRavF8B7wWI/ZeHt2cEulfcUu9tExhGy3vMmcTir7QG8tl2e+R7ozy3ylJvb4iCtAAAAcDBuBgkqhkiG9w0BBwagYTBfAgEAMFoGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMmp42tSOwS/UTXyfoAgEQgC0Dm0HS2bhQNVIOPx0qWB74bKAPb9Ji0pt6fGhuf5wFPlNPINmjUiGGG7H748g="
  }
}
