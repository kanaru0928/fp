# frozen_string_literal: true

require_relative 'scene'

module Settings
  WIDTH = 480.0
  HEIGHT = 360.0
  VFOV = 60.0
  NUM_SAMPLE = 4
end

def main
  scene = Scene.new(Settings::WIDTH, Settings::HEIGHT, Settings::VFOV, Settings::NUM_SAMPLE)
  scene.build
  scene.render
  scene.write('img2.ppm')
end

main
