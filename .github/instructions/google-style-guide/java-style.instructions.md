---
description: "Use when writing, reviewing, or modifying Java code. Enforces Google Java Style Guide conventions for formatting, naming, imports, Javadoc, annotations, braces, exceptions, and programming practices."
applyTo: "**/*.java"
---

# Google Java Style Guide

Reference: https://google.github.io/styleguide/javaguide.html

## Formatting

- **Indentation**: 2 spaces. Never tabs.
- **Continuation indent**: +4 spaces from the original line.
- **Column limit**: 100 characters. Exceptions: package declarations, imports, long URLs in comments, text block contents.
- **One statement per line**.
- **Braces required** on `if`, `else`, `for`, `do`, `while` — even when the body is empty or a single statement.
- **K&R brace style**: opening brace on same line, closing brace on its own line. No line break before `{`; line break after `{` and before `}`.
- **Empty blocks** may use concise form `{}` unless part of a multi-block statement (`if/else`, `try/catch/finally`).
- **One variable per declaration**: no `int a, b;`. Exception: `for` loop headers.
- **Switch indentation**: contents indented +2 from `switch`. Use `// fall through` comment for old-style fall-through. Every switch must be exhaustive (include `default` if needed).
- **Annotations**: class/method/constructor annotations each on their own line. Exception: a single parameterless annotation may share the line with the signature (`@Override public int hashCode()`). Field annotations may share a line.
- **Modifiers order**: `public protected private abstract default static final sealed non-sealed transient volatile synchronized native strictfp`.
- **Numeric literals**: use uppercase `L` suffix for `long` values (`3000000000L`, not `3000000000l`).
- **No C-style array declarations**: use `String[] args`, not `String args[]`.

## Naming Conventions

| Type | Convention | Examples |
|------|-----------|----------|
| Packages / Modules | `alllowercase` (no underscores) | `com.example.deepspace` |
| Classes / Interfaces / Enums / Annotations / Records | `UpperCamelCase` | `ImmutableList`, `Readable` |
| Methods | `lowerCamelCase` (verbs/verb phrases) | `sendMessage`, `stop` |
| Constants (`static final`, deeply immutable) | `UPPER_SNAKE_CASE` | `MAX_SIZE`, `EMPTY_ARRAY` |
| Non-constant fields / Parameters / Local variables | `lowerCamelCase` | `computedValues`, `index` |
| Type variables | Single capital letter or `NameT` | `E`, `T2`, `RequestT` |

- No Hungarian notation or special prefixes/suffixes (`mName`, `s_name`, `name_`, `kName` are all forbidden).
- Test classes end with `Test` (e.g., `HashImplTest`).
- Camel case rule for acronyms: `XmlHttpRequest` (not `XMLHTTPRequest`), `newCustomerId` (not `newCustomerID`).

## Imports

- **No wildcard imports** — static or otherwise.
- **No module imports** (`import module java.base;` is not used).
- **No line-wrapping** of import statements.
- **Ordering**: (1) all static imports in one group, (2) all non-static imports in one group. Single blank line between the two groups. Within each group, ASCII sort order by full import path.
- **No static import for nested classes** — use normal imports for static nested classes.

## Javadoc

- Required on every `public`/`protected` class, member, and record component (unless self-explanatory or an `@Override`).
- **Format**: `/** ... */`. Single-line form allowed if no block tags and fits on one line.
- **Summary fragment**: a noun or verb phrase (not a full sentence), capitalized and punctuated as a sentence. Never starts with `A {@code Foo} is...` or `This method returns...`.
- **Block tags order**: `@param`, `@return`, `@throws`, `@deprecated`. Never empty descriptions.
- **Paragraphs**: separated by a blank `*` line; subsequent paragraphs start with `<p>` (no space after).

## Programming Practices

- **`@Override` always used** on every legal override (class→superclass, class→interface, interface→superinterface). May omit only when parent is `@Deprecated`.
- **Caught exceptions never ignored**. At minimum, log or comment explaining why no action is taken.
- **Static members qualified by class name**: `Foo.staticMethod()`, never `instanceRef.staticMethod()`.
- **Finalizers not used** — never override `Object.finalize()`.
- **One top-level class per file**, named to match the file name.

## Source File Structure

Order within a `.java` file:
1. License/copyright comment (if any)
2. `package` declaration (not line-wrapped)
3. Imports
4. Exactly one top-level class

Exactly one blank line between each section. Overloaded methods must appear contiguously.

---

## Enforcement

### google-java-format

The canonical formatter for Google Java Style.

**Standalone usage:**
```bash
# Format in place
google-java-format --replace src/main/java/**/*.java

# Check formatting (CI mode — exits non-zero on diff)
google-java-format --dry-run --set-exit-if-changed src/main/java/**/*.java
```

**Gradle plugin (`build.gradle`):**
```groovy
plugins {
  id 'com.github.sherter.google-java-format' version '0.9'
}

googleJavaFormat {
  toolVersion = '1.25.2'
}

// Run: ./gradlew googleJavaFormat
// Check: ./gradlew verifyGoogleJavaFormat
```

**Maven plugin (`pom.xml`):**
```xml
<plugin>
  <groupId>com.spotify.fmt</groupId>
  <artifactId>fmt-maven-plugin</artifactId>
  <version>2.25</version>
  <executions>
    <execution>
      <goals>
        <goal>format</goal>
      </goals>
    </execution>
  </executions>
</plugin>
<!-- Run: mvn fmt:format -->
<!-- Check: mvn fmt:check -->
```

### Checkstyle (Google Checks)

Uses the official `google_checks.xml` from https://github.com/checkstyle/checkstyle.

**Gradle (`build.gradle`):**
```groovy
plugins {
  id 'checkstyle'
}

checkstyle {
  toolVersion = '10.21.4'
  configFile = file("${project.rootDir}/config/checkstyle/google_checks.xml")
  maxWarnings = 0
}

// Run: ./gradlew checkstyleMain checkstyleTest
```

**Maven (`pom.xml`):**
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-checkstyle-plugin</artifactId>
  <version>3.6.0</version>
  <configuration>
    <configLocation>google_checks.xml</configLocation>
    <consoleOutput>true</consoleOutput>
    <failsOnError>true</failsOnError>
  </configuration>
  <dependencies>
    <dependency>
      <groupId>com.puppycrawl.tools</groupId>
      <artifactId>checkstyle</artifactId>
      <version>10.21.4</version>
    </dependency>
  </dependencies>
  <executions>
    <execution>
      <goals>
        <goal>check</goal>
      </goals>
    </execution>
  </executions>
</plugin>
<!-- Run: mvn checkstyle:check -->
```

Download `google_checks.xml`:
```bash
curl -LO https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml
mkdir -p config/checkstyle && mv google_checks.xml config/checkstyle/
```

### pre-commit Hook

**.pre-commit-config.yaml:**
```yaml
repos:
  - repo: https://github.com/macisamuele/language-formatters-pre-commit-hooks
    rev: v2.14.0
    hooks:
      - id: pretty-format-java
        args: [--autofix, --google-java-formatter-version=1.25.2]
```

```bash
# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

### Setup Instructions

1. **Pick a formatter**: Install `google-java-format` via the Gradle/Maven plugin shown above, or download the [standalone JAR](https://github.com/google/google-java-format/releases).
2. **Add Checkstyle**: Download `google_checks.xml` and configure the Gradle or Maven plugin.
3. **Add pre-commit hook**: Copy the `.pre-commit-config.yaml` snippet above and run `pre-commit install`.
4. **IDE integration**: Install the `google-java-format` plugin for IntelliJ IDEA or VS Code, and configure it as the default formatter. Set indent to 2 spaces.
5. **CI**: Add `verifyGoogleJavaFormat` (Gradle) or `fmt:check` (Maven) and `checkstyle:check` to your CI pipeline to block non-conforming code.
