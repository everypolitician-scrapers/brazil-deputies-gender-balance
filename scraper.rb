#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'everypolitician'
require 'pry'
require 'scraperwiki'

require_rel 'lib/score'

URL = 'http://www.gender-balance.org/export/Brazil/Deputies'
data = GenderScore.new(open(URL).read).results

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite(%i(uuid), data)
