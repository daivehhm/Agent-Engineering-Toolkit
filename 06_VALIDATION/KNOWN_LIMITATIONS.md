# Known Limitations — v1.6.1
1. Native Windows runtime still must be executed on the target machine before setup can be verified.
2. Agent permissions are external to the Toolkit; AET does not disable sandbox boundaries.
3. Static adapter/config presence does not prove a fresh session actually loaded the rules.
4. Vendor paths/precedence can change; revalidate after updates.
5. Instruction-level safety is not an OS-level shell interceptor. `FS_SEARCH_SAFETY_V1` reduces unsafe Agent decisions but cannot guarantee prevention against every alternate execution path.
6. Subagent inheritance must be runtime-proven where the product supports subagents; do not infer it.
7. Automatic rollback is not transaction-managed; installers use WhatIf/backups/marker-scoped changes instead of a new rollback platform.
8. Project contract content cannot be universally auto-inferred.
