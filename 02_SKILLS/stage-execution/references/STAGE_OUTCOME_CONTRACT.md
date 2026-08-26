# Stage Outcome Contract

## Purpose
`stage_outcome.json` is the minimum formal Stage outcome summary. It lets AET accumulate real evidence about false PASS, review rounds, path failures, blockers, and Human Gate outcomes without building an Evaluation Platform.

Required for `STAGE_WORK` and `FORMAL_ACCEPTANCE`; normally not required for `SMALL_CHANGE`.

## Schema
```json
{
  "schema_version":"1.0",
  "stage_id":"STAGE_ID",
  "work_class":"STAGE_WORK",
  "builder_agent":"unknown",
  "required_review_level":"R1",
  "implementation_exit":"IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW",
  "unit_result":"PASS",
  "path_result":"PASS",
  "runtime_result":"PASS",
  "independent_review_result":"PENDING",
  "review_rounds":0,
  "blocker_count":0,
  "false_signoff_detected":false,
  "human_gate_required":false,
  "human_result":"NOT_REQUIRED"
}
```

Evidence result values: `PASS`, `FAIL`, `NOT_REQUIRED`, `NOT_RUN`, `BLOCKED`, `UNKNOWN`.
Review result values: `PENDING`, `PASS`, `PASS_WITH_NONBLOCKING_ITEMS`, `FAIL`, `READY_FOR_HUMAN_REVIEW`, `READY_FOR_NEXT_STAGE`.
Human result values: `NOT_REQUIRED`, `PENDING`, `ACCEPT`, `REJECT`.

## Integrity
This is a derived summary. Test runner/runtime artifact/Independent Review/Human review outrank it. If they conflict, canonical evidence wins and this file must be corrected.

Do not add ranking algorithms, weighted model scores, dashboards, or leaderboard dependencies without real evidence.
