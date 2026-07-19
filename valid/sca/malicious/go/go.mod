// Go malicious-module SCA fixture.
// Verified present in cas_malicious_packages Firestore (MAL-2026-3620).
// Module github.com/BufferZoneCorp/config-loader, affected range introduced:"0"
// (all versions). The packages-api /query endpoint returns isMalicious:true.
// This case also exercises the doc-id "/" -> "__" sanitisation
// (doc id stored as Go:github.com__BufferZoneCorp__config-loader).
module example.com/malicious-package-fixture

go 1.22

require (
	github.com/BufferZoneCorp/config-loader v1.0.0 // malicious
	github.com/google/uuid v1.6.0 // benign control (should NOT be flagged)
)
