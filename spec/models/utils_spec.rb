require 'spec_helper'

describe String do
  describe '#has_emoji?' do
    it 'works' do
      expect('ほげ'.has_emoji?).to be_falsey
      expect("a 🍰".has_emoji?).to be_truthy
      expect(" マルチバイト 🐬 ".has_emoji?).to be_truthy
    end
  end
end
