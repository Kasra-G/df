# Kotlin Code Preferences

> Also apply preferences from `general.md`

## Style & Formatting
- Use trailing commas in parameter lists, argument lists, and collection literals
- Use `object` for stateless singletons and utility namespaces instead of classes with companion objects
- Use `require()` and `check()` for preconditions instead of manual `if`/`throw`

## Dependency Injection (Dagger)
- Prefer `@Inject constructor()` + `@Singleton` over `@Provides` in modules when possible
- Use `@Binds` over `@Provides` when the method just returns an injected implementation as its interface type

## Testing
- Prefer Kotest matchers (`shouldBe`, `shouldContain`, `shouldThrow`) over JUnit assertions when the project uses Kotest
- Use `@Nested` inner classes to group related test cases
- Name test functions with backticks: `` `should return empty list when no items match` ``
- Use `slot<T>()` and `capture()` to verify argument values instead of complex `verify` matchers
- Use `clearAllMocks()` in `@AfterEach` rather than `@BeforeEach` to avoid masking isolation issues
- Prefer `runTest` for coroutine tests over `runBlocking`

## Error Handling
- Prefer `Result<T>` or sealed result types over throwing exceptions for domain/business operations

## Patterns
- Use `typealias` for complex generic types to improve readability (e.g., `typealias Handler = (Request) -> Response`)
