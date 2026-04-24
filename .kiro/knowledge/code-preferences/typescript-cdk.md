# TypeScript / CDK Code Preferences

> Also apply preferences from `general.md`

## CDK Infrastructure
- Program to interfaces, not implementations (e.g., `ITable` over `SecureTable` in props)
- Use `Bucket.fromBucketName()` / `Table.fromTableArn()` for cross-stack references instead of passing full construct references
- Set `removalPolicy: RemovalPolicy.RETAIN` on stateful resources (DynamoDB, S3) explicitly
- Let CDK auto-generate resource names — don't set `functionName`, `queueName`, etc. unless required
- Don't over-provision infra upfront — skip log groups, alarms, dashboards until actually needed
- Don't add placeholder IAM permissions with wildcard `*` and TODOs — add permissions when the code exists
- Prefer inline props (e.g., `targets: [...]` in constructor) over post-construction calls (`rule.addTarget()`)
- Group related constructs into a single Construct subclass rather than spreading across the Stack

## TypeScript Style
- Use `readonly` on interface properties and function parameters that shouldn't be mutated
- Avoid `any`

## Testing
- Mock at module boundaries (AWS SDK clients, HTTP clients), not internal functions
