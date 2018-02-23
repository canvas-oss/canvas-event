# Copyright 2018-02-22
# Remy BOISSEZON boissezon.remy@gmail.com
# Valentin PRODHOMME valentin@prodhomme.me
# Dylan TROLES chill3d@protonmail.com
# Alexandre ZANNI alexandre.zanni@engineer.com
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software.  You can  use,
# modify and/ or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.

require 'test_helper'

class CanvasOss::EventTest < Minitest::Test
  def setup
    @logger = CanvasOss::Event::Logger.new('canvas_test', 0)
  end

  def test_that_it_has_a_version_number
    refute_nil ::CanvasOss::Event::VERSION
  end

  def test_that_the_connect_facility_id_is_valid
    (0..7).each do |facility|
      assert CanvasOss::Event::Logger.new('canvas_test', facility)
    end
    assert_raises(StandardError) { CanvasOss::Event::Logger.new('canvas_test', 8) }
    assert_raises(StandardError) { CanvasOss::Event::Logger.new('canvas_test', -1) }
  end

  def test_that_the_connect_program_name_is_valid
    assert CanvasOss::Event::Logger.new('canvas_test', 0)
    assert_raises(ArgumentError) { CanvasOss::Event::Logger.new(0, 0) }
  end

  def test_that_the_log_severity_is_valid
    %w[alert error warn info debug].each do |severity|
      assert @logger.log(severity, 'msg ' + severity)
    end
    assert_raises(StandardError) { @logger.log(0, 'msg') }
    assert_raises(StandardError) { @logger.log('falsevalue', 'msg') }
  end

  def test_that_the_log_message_is_valid
    assert @logger.log('alert', 'log message valid')
    assert_raises(ArgumentError) { @logger.log('alert', 0) }
  end
end
