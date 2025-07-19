Kernel.eval(command_options) unless command_options.nil? # rubocop:disable Security/Eval

# This file is used to evaluate Ruby code dynamically. It is used to communicate between Cypress tests
# and the Ruby backend for test setup etc.
# It should be used with caution as it can execute arbitrary code.
# Ensure that `command_options` is sanitized and safe before using this.
