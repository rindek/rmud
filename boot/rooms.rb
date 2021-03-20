# frozen_string_literal: true
App.boot(:rooms) { start { register(:rooms, Engine::Rooms::Loader.load!) } }
