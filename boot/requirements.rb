# frozen_string_literal: true
App.boot(:requirements) do
  start do
    use :bundler
    use :mongo
    use :zeitwerk
    use :types
    use :import
  end
end
