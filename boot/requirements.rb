# frozen_string_literal: true
App.boot(:requirements) do
  start do
    use :bundler
    use :persistence
    use :zeitwerk
  end
end
