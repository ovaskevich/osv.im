/**
 * Global DNS configuration for osv.im.
 */

resource "aws_route53_zone" "root" {
  name = "osv.im."
}

// MX and SPF records for sending mail via Pobox.

resource "aws_route53_record" "root_mx" {
  name    = "osv.im."
  type    = "MX"
  zone_id = aws_route53_zone.root.zone_id
  ttl     = "300"

  records = [
    "10 mx-2.rightbox.com",
    "10 mx-1.rightbox.com",
    "10 mx-3.rightbox.com",
  ]
}

resource "aws_route53_record" "root_spf" {
  name    = "osv.im."
  type    = "SPF"
  zone_id = aws_route53_zone.root.zone_id
  ttl     = "300"
  records = ["v=spf1 include:pobox.com ?all"]
}

resource "aws_route53_record" "root_txt" {
  name    = "osv.im."
  type    = "TXT"
  zone_id = aws_route53_zone.root.zone_id
  ttl     = "300"

  records = [
    "v=spf1 include:pobox.com ?all",
    "keybase-site-verification=WpdG73nB_cS7PvZ5RkYYcaPerhAQ53w-gI5wZECg_Ek",
    "google-site-verification=HXLLD-2vE_1Gl4VpXR_GZjrwHXM6jBDasMmBIqxK-H0",
  ]
}

// Set up a redirect from www to the naked domain.

resource "aws_route53_record" "www_cname" {
  name    = "www.osv.im."
  type    = "CNAME"
  zone_id = aws_route53_zone.root.zone_id
  ttl     = "600"
  records = ["osv.im"]
}

// Delegate shado.osv.im to a hosted zone in a different account.

resource "aws_route53_record" "shado" {
  name    = "shado.osv.im"
  type    = "NS"
  zone_id = aws_route53_zone.root.zone_id
  ttl     = "1800"

  records = [
    "ns-1127.awsdns-12.org",
    "ns-865.awsdns-44.net",
    "ns-2009.awsdns-59.co.uk",
    "ns-62.awsdns-07.com",
  ]
}

