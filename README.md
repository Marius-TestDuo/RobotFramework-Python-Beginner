# Robot Framework Automation Template - Environment Setup

This repository bootstraps an automation environment for:
- Robot Framework
- Selenium (web)
- Appium (mobile)
- REST API (RequestsLibrary)

## Quick start (Windows PowerShell)

1) Create and populate a Python virtual environment

```
powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1
```

This will:
- Create `.venv/`
- Upgrade `pip`
- Install packages from `requirements.txt`
- No manual WebDriver download required; Selenium Manager (Selenium 4+) manages browser drivers.

2) Activate the environment for your shell session

```
.\.venv\Scripts\Activate.ps1
```

3) Verify tools

```
robot --version
python -c "import SeleniumLibrary, AppiumLibrary, RequestsLibrary; print('OK')"
```

4) Run tests via helper (uses shared args)

```
run_robot.bat tests\web\suites -i smoke
```

## Web drivers
- Selenium 4+ includes Selenium Manager, which auto-downloads Chrome/Edge/Firefox drivers when WebDriver starts (works with SeleniumLibrary).
- Optional: If you need explicit control or prefetch in CI, use `webdrivermanager`.

```
pip install webdrivermanager
.\.venv\Scripts\python -m webdrivermanager chrome --linkpath .\drivers
```

Then ensure the driver path is on `PATH` or configure SeleniumLibrary explicitly if auto-detection fails.

## Appium server (required for mobile)
- Install Node.js LTS
- Install Appium globally: `npm i -g appium`
- Optionally: `npm i -g @appium/doctor` then run `appium-doctor --android` and/or `--ios`
- Start server: `appium`

## Next steps (suggested layout)
```
resources/           # Reusable keywords and locators
variables/           # Env- and suite-level variables
libraries/           # Custom Python libraries
configs/             # Environment config (YAML/JSON)

tests/web/           # Web UI tests (SeleniumLibrary)
tests/api/           # API tests (RequestsLibrary)
tests/mobile/        # Mobile tests (AppiumLibrary)
```

## Naming Conventions

Project structure aligns with web, API, and mobile separation. Use consistent, review-friendly names.

- Files: descriptive, lowercase, underscores; avoid spaces.
  - Test suites (tests/<area>/suites): `login_smoke.robot`, `cart_regression.robot`
  - Resources (keywords/locators/variables) use `.resource`: `login_page.resource`, `common_nav.resource`, `environment.resource`
  - Variables (alt): `.robot` also acceptable for variable-only resources: `environment.robot`
  - Python libraries: `libraries/<domain>/`: `date_utils.py`, `selenium_extras.py`

- Keywords: Title Case with spaces, action-first, business-readable.
  - Examples: `Login With Credentials`, `Open User Menu`, `Add Item To Cart`
  - Keep keywords in resources; tests should call keywords, not raw locators.

- Variables: UPPER_SNAKE_CASE for constants; lower_snake_case for locators
  - Scalars: `${SUT}`, `${BROWSER}`, `${TIMEOUT}`
  - Lists/Dicts: `@{USERS}`, `&{HEADERS}`
  - Locators: `${username_txt}`, `${sign_in_btn}`, `${forgot_password_lnk}`

- Locators (web): prefer stable CSS with `data-test` attributes; use XPath only when needed for complex relations.
  - Common/global locators in `tests/web/resources/locators/common/`
  - Page-specific locators in `tests/web/resources/locators/pages/` (one file per page)
  - Parameterized locators: use keywords to compose or placeholders inside keywords.

- Tags: lowercase, purpose- and domain-oriented.
  - Type: `smoke`, `regression`, `e2e`
  - Domain: `web`, `api`, `mobile`
  - Feature: `auth`, `checkout`, `profile`

- Environments and config: keep non-sensitive defaults in resources or variable files under `configs/environments/`.
  - Files: `dev.py`, `stage.py`, `prod.py` (Python variable files) or `*.resource` variable files
  - Override via CLI: `--variable SUT:https://staging.example.com`

- File extensions and paths:
  - Test suites: `.robot`
  - Robot resources: `.resource` (or `.robot` if preferred), imported with `Resource`
  - Python libraries: `.py`, imported with `Library` and `-P libraries`/`--pythonpath libraries`
  - Argfile: `.args` under `configs/robot/`

- Suggested affixes (optional but helpful):
  - Elements: `_txt` (input), `_btn` (button), `_lnk` (link), `_sel` (select), `_chk` (checkbox), `_rad` (radio)
  - Messages: `_msg`, Sections: `_sec`, Modals: `_mod`

Consistency tips
- Keep resource files small and cohesive; split when >200-300 lines.
- Expose actions as keywords; keep locators and low-level steps private inside resources.
- Avoid one giant global locator file; only truly shared elements live under `locators/common`.

## Locators to use
- id: element by id. Example: id:username
- name: element by name. Example: name:q
- xpath: XPath selector. Example: //input[@data-test='username']
- css: CSS selector. Example: css:[data-test='login-button']
- class name: by class. Example: class:btn-primary
- tag name: by tag. Example: tag:input
- link text: full link text. Example: link:Sign in
- partial link text: partial link. Example: partial link:Sign