module.exports = (since, till=new Date()) ->
  inWords till.getTime() - since.getTime()
module.exports.settings =
  allowFuture: false
  prefixAgo: null
  prefixFromNow: null
  suffixAgo: "ago"
  suffixFromNow: "from now"
  seconds: "less than a minute"
  minute: "about a minute"
  minutes: "%d minutes"
  hour: "about an hour"
  hours: "about %d hours"
  day: "a day"
  days: "%d days"
  month: "about a month"
  months: "%d months"
  year: "about a year"
  years: "%d years"
  numbers: []

inWords = (distanceMillis) ->
  settings = module.exports.settings
  substitute = (stringOrFunction, number) ->
    string = (if typeof stringOrFunction is "function" then stringOrFunction(number, distanceMillis) else stringOrFunction)
    value = (settings.numbers and settings.numbers[number]) or number
    string.replace /%d/i, value
  prefix = settings.prefixAgo
  suffix = settings.suffixAgo
  if settings.allowFuture
    if distanceMillis < 0
      prefix = settings.prefixFromNow
      suffix = settings.suffixFromNow
  seconds = Math.abs(distanceMillis) / 1000
  minutes = seconds / 60
  hours = minutes / 60
  days = hours / 24
  years = days / 365
  words = seconds < 45 and substitute(settings.seconds, Math.round(seconds)) or seconds < 90 and substitute(settings.minute, 1) or minutes < 45 and substitute(settings.minutes, Math.round(minutes)) or minutes < 90 and substitute(settings.hour, 1) or hours < 24 and substitute(settings.hours, Math.round(hours)) or hours < 48 and substitute(settings.day, 1) or days < 30 and substitute(settings.days, Math.floor(days)) or days < 60 and substitute(settings.month, 1) or days < 365 and substitute(settings.months, Math.floor(days / 30)) or years < 2 and substitute(settings.year, 1) or substitute(settings.years, Math.floor(years))
  [prefix, words, suffix].join(" ").toString().trim()