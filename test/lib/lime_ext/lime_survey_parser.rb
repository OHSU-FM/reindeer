require 'test_helper'

describe LimeExt::LimeSurveyParser do

  it 'Should require three dictionaries to init' do
    LimeExt::LimeSurveyParser.new({}, {}, {})
    assert_raises ArgumentError do
      LimeExt::LimeSurveyParser.new({})
    end
    assert_raises ArgumentError do
      LimeExt::LimeSurveyParser.new({}, {})
    end
  end

  it 'Should substitute values for token record values' do
    rec_row = {name: 'Bill'}
    tok_row = {attribute_1: '33', attribute_2: 'and 1/2'}
    tok_inf = {}
    parser = LimeExt::LimeSurveyParser.new(rec_row, tok_row, tok_inf)
    input = 'Hi, I am {name} and I am {TOKEN:ATTRIBUTE_1} {TOKEN:ATTRIBUTE_2} years old'
    output = 'Hi, I am Bill and I am 33 and 1/2 years old'
    parser.parse(input).must_equal(output)
  end


end
