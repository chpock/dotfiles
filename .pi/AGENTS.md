# Local Pi configuration

## Model switches

Before changing a configured model, including a temporary switch or a subagent model, confirm that the exact `provider/model` is available in Pi for the account and authentication method in use. For GitHub Copilot OAuth, check the account's `availableModelIds` without exposing credentials. An entry in the general model catalog or `enabledModels` does not confirm access. Check availability without sending a model request. If you cannot confirm it, leave the setting unchanged and report what blocked the check.
