require 'rails_helper'

RSpec.describe Occupation, type: :model do
  describe '#long_description' do
    it 'returns the correct long description' do
      create(:occupation, major_label: 'Engineering', description: 'Civil Engineer')
      create(:occupation, major_label: 'Finance', description: 'Accountant')
      create(:occupation, major_label: 'Engineering', description: 'Software Developer')
      create(:occupation, major_label: 'Finance', description: 'Financial Analyst')

      expect(Occupation.all.map(&:long_description)).to eq([
        'Engineering > Civil Engineer',
        'Engineering > Software Developer',
        'Finance > Accountant',
        'Finance > Financial Analyst'
      ])
    end
  end
end
