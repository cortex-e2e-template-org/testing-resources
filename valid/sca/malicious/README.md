# Malicious-package SCA fixtures (BCE-60145 verification)

These manifests each declare **one known-malicious package** that is verified to
exist in the `cas_malicious_packages` Firestore collection on tenant
`9997889169501`, plus **one benign control package** that should NOT be flagged.

They were produced to validate the BCE-60145 fix (packages-api Firestore doc-ID
case mismatch). The packages-api `/query` endpoint was confirmed to return
`isMalicious: true` for every package below on the live tenant.

| Ecosystem | File | Malicious package | Version | Malware ID |
|---|---|---|---|---|
| PyPI | `python/requirements.txt` | `0-8` | 0.0.0.1 | MAL-2025-2925 |
| Maven | `maven/pom.xml` | `io.github.leetcrunch:scribejava-core` | 8.3.5 | MAL-2025-2552 |
| NuGet | `nuget/packages.config` | `2CaptcһaAPІ` (homoglyphs!) | 1.10.1 | MAL-2024-3991 |
| Go | `go/go.mod` | `github.com/BufferZoneCorp/config-loader` | v1.0.0 | MAL-2026-3620 |
| RubyGems | `ruby/Gemfile` | `1-as-identity_function` | 1.0.1 | MAL-2024-6265 |
| Packagist | `php/composer.json` | `intercom-php` | 5.0.2 | MAL-2026-3637 |

## Important notes

- **NuGet name uses Cyrillic homoglyphs.** `2CaptcһaAPІ` is NOT plain ASCII
  (the `һ` is U+04BB and the `І` is U+0406). Do not retype it — copy the exact
  bytes from `nuget/packages.config`, or the lookup will not match.

- **Go** intentionally exercises the doc-ID `/` → `__` sanitisation that was part
  of the fix. The input module name has slashes
  (`github.com/BufferZoneCorp/config-loader`); the service maps it to the stored
  doc id `Go:github.com__BufferZoneCorp__config-loader`.

- **Versions matter.** The `/query` path filters out results whose version is not
  affected by the advisory, so the exact versions above were chosen because they
  are within each advisory's affected set (Maven and Go use `introduced:"0"`,
  i.e. all versions affected).

- The benign control packages (requests, guava, Newtonsoft.Json, google/uuid,
  rake, monolog) are current, legitimate releases and should produce no
  malicious finding — useful to confirm there are no false positives.

## Why these are guaranteed to match (verification trail)

Verified end-to-end against the scanner-sca source and the live tenant:

1. **API confirms malicious** — each (ecosystem, name, version) above was sent to
   the deployed packages-api `/query` endpoint on tenant 9997889169501 and
   returned `isMalicious: true` with the listed MAL- id.

2. **Static extractors emit the exact name** (no registry resolution needed, so
   they work even if cdxgen fails to resolve the malicious package):
   - Maven `mavenExtractor.go` → `Package = groupId + ":" + artifactId`
     (`io.github.leetcrunch:scribejava-core`).
   - Go `goExtractor.go` → module path verbatim from go.mod
     (`github.com/BufferZoneCorp/config-loader`).
   - PyPI / NuGet / RubyGems / Packagist use pure static parsers
     (requirements.txt, packages.config, Gemfile, composer.json).

3. **Name reaches the API case-preserved** — `malicious-packages-fetcher.ts`
   sends `name: pkg.name` verbatim; the only lowercasing is on an internal
   result-map key, which does not affect the Firestore doc-id lookup.

4. **Versions match regardless of format** — every advisory above is either
   Tier-1 "all versions affected" (`introduced: "0"`: Maven, Go) or an exact
   version match (PyPI, NuGet, RubyGems, Packagist), so e.g. the Go `v1.0.0`
   vs `1.0.0` difference is irrelevant.

The only operational prerequisite is that the scan runs the static-analysis
path and the SCA findings phase queries packages-api (the default in-cluster
flow).
