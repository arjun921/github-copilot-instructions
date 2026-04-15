---
description: "Use when writing, reviewing, or modifying AngularJS (1.x) code. Enforces Google AngularJS Style Guide conventions for modules, controllers, directives, services, formatting, and AngularJS-specific best practices."
---

# Google AngularJS Style Guide

Reference: https://google.github.io/styleguide/angularjs-google-style.html

> **Note:** AngularJS (1.x) reached end-of-life on December 31, 2021. This guide is for maintaining legacy AngularJS codebases. For new projects, use Angular (2+) instead.

## Modules

- Define one module per file. A module should never be altered other than in the file where it is defined.
- The main application module should live in the root client directory.
- Reference other modules using the Angular module's `.name` property, not duplicated string literals.

```javascript
// Yes — use .name property
my.application.module = angular.module('hello', [my.submoduleA.name]);

// No — duplicated string
my.application.module = angular.module('hello', ['my.submoduleA']);
```

- Modules may be defined in the same file as their single component, or in a separate wiring file for multi-component modules.

## Controllers

- Controllers are classes. Define methods on the prototype.
- Use `controllerAs` syntax to export the controller onto the scope. Avoid manipulating `$scope` directly.
- Name controllers in `UpperCamelCase` with a `Ctrl` or `Controller` suffix (e.g., `HomeCtrl`, `SettingsController`).
- Bind properties and methods to `this`, not to `$scope`.

```javascript
/**
 * Home controller.
 * @constructor
 * @ngInject
 * @export
 */
hello.mainpage.HomeCtrl = function() {
  /** @type {string} @export */
  this.myColor = 'blue';
};

hello.mainpage.HomeCtrl.prototype.add = function(a, b) {
  return a + b;
};
```

```html
<!-- Use controllerAs in templates -->
<div ng-controller="hello.mainpage.HomeCtrl as homeCtrl">
  <span ng-class="homeCtrl.myColor">I'm in a color!</span>
  <span>{{homeCtrl.add(5, 6)}}</span>
</div>
```

- Using `controllerAs` makes it obvious which controller owns a binding when multiple controllers apply to an element.
- A dot in bindings (e.g., `homeCtrl.value`) prevents prototypal inheritance from masking primitives.

## Directives

- All DOM manipulation must happen inside directives. Keep directives small and compose them.
- Restrict directives to elements (`E`) and attributes (`A`). Avoid class (`C`) or comment (`M`) restrictions.
- Use isolate scope to make directives reusable and avoid scope leakage.
- Prefix custom directive names to avoid collisions with third-party directives (e.g., `myApp` prefix → `myAppDatePicker`).
- Directive names use `camelCase` in JavaScript and `kebab-case` in HTML.

```javascript
// JavaScript — camelCase
hello.pane.paneDirective = function() {
  return {
    restrict: 'EA',
    scope: {},
    templateUrl: 'pane.html',
    controller: 'PaneCtrl',
    controllerAs: 'paneCtrl'
  };
};
```

```html
<!-- HTML — kebab-case -->
<hello-pane></hello-pane>
```

- Exception: DOM manipulation may occur in services for DOM elements disconnected from the view (e.g., dialogs, keyboard shortcuts).

## Services

- Use `module.service` to register services as classes. Prefer `module.service` over `module.provider` or `module.factory` unless initialization beyond instantiation is needed.
- Name services in `camelCase`.

```javascript
/**
 * @param {!angular.$http} $http
 * @constructor
 */
hello.request.Request = function($http) {
  /** @type {!angular.$http} */
  this.http_ = $http;
};

hello.request.Request.prototype.get = function() { /*...*/ };

// Registration
module.service('request', hello.request.Request);
```

## Templates

- Prefer `ng-bind` or one-time binding `{{ ::expression }}` over `{{ expression }}` to reduce unnecessary watches and improve performance.
- Use one-time bindings for data that does not change after initial render.

```html
<!-- Yes — one-time binding -->
<span>{{ ::vm.staticLabel }}</span>

<!-- Yes — ng-bind -->
<span ng-bind="vm.dynamicValue"></span>

<!-- Avoid for static data -->
<span>{{ vm.staticLabel }}</span>
```

## Dependency Injection

- Use the `$inject` property annotation to declare dependencies. This survives minification and is readable.
- If using Closure Compiler, use the `@ngInject` annotation instead, which generates `$inject` automatically.

```javascript
// $inject annotation (preferred without Closure Compiler)
MyCtrl.$inject = ['$http', 'myService'];
function MyCtrl($http, myService) {
  // ...
}

// @ngInject annotation (with Closure Compiler)
/** @ngInject */
my.app.MyCtrl = function($http, myService) {
  // ...
};
```

- Do **not** use implicit annotation (bare parameter names) — it breaks on minification.
- Do **not** use inline array annotation (`['$http', function($http) {}]`) — it is harder to read and maintain at scale.

## Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Modules | `camelCase` | `my.submoduleA` |
| Controllers | `UpperCamelCase` + `Ctrl`/`Controller` | `HomeCtrl`, `SettingsController` |
| Services | `camelCase` | `request`, `userService` |
| Directives (JS) | `camelCase` | `myAppDatePicker` |
| Directives (HTML) | `kebab-case` | `my-app-date-picker` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |

- Reserve `$` prefix for Angular built-in properties and services. Never use `$` to prefix your own identifiers.

```javascript
// Yes
$scope.myModel = { value: 'foo' };
myModule.service('myService', function() { /*...*/ });

// No
$scope.$myModel = { value: 'foo' };          // BAD
myModule.service('$myService', function() {}); // BAD
```

## File Organization

- One component per file (one controller, directive, service, or filter per file).
- Use a feature-based directory structure, grouping related controllers, services, directives, and templates together.

```
app/
├── app.module.js
├── home/
│   ├── home.module.js
│   ├── home.controller.js
│   ├── home.html
│   └── home.css
├── settings/
│   ├── settings.module.js
│   ├── settings.controller.js
│   └── settings.html
└── components/
    ├── navbar/
    │   ├── navbar.directive.js
    │   └── navbar.html
    └── user-service/
        └── user.service.js
```

## Testing

- Angular is designed for test-driven development. Write unit tests for all controllers, services, and directives.
- Recommended setup: Jasmine + Karma.
- Use `angular.mock.module` and `angular.mock.inject` to load modules and inject dependencies in tests.
- Be aware of scope prototypal inheritance nuances when writing tests that manipulate scope.

## Enforcement

### ESLint Configuration

```json
{
  "extends": ["eslint:recommended"],
  "plugins": ["angular"],
  "rules": {
    "angular/controller-as": "error",
    "angular/controller-as-vm": ["error", "vm"],
    "angular/no-run-on-ng-module": "error",
    "angular/no-services": ["error", ["$http", "$resource"]],
    "angular/di-order": ["error", true],
    "angular/function-type": ["error", "named"]
  },
  "env": {
    "browser": true
  },
  "globals": {
    "angular": "readonly"
  }
}
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v9.17.0
    hooks:
      - id: eslint
        additional_dependencies:
          - eslint-plugin-angular@4.1.0

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
```

### Setup Instructions

```bash
# Install ESLint with AngularJS plugin
npm install --save-dev eslint eslint-plugin-angular

# Run ESLint
npx eslint "**/*.js"

# Autofix
npx eslint --fix "**/*.js"
```
