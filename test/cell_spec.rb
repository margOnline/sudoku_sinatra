require 'cell'

describe Cell do

  let(:cell){Cell.new(4)}

  it 'knows if it is filled in' do
    expect(cell.filled_in?).to be_true
  end

  it 'knows if it is not filled in' do
    cell = Cell.new
    expect(cell.filled_in?).to be_false
  end

  it 'identifies possible candidates' do
    cell.neighbours = [1,2,3,5,7,9,3,5].map{|n| double(:cell,{:value => n})}
    expect(cell.identify_candidates).to eq [4,6,8]
  end

  context 'assigns a value' do
    let(:cell){Cell.new}

    it 'if there is only 1 possible value for it' do
      cell.neighbours = [1,3,4,5,6,7,8,9].map{|n| double(:cell,{:value => n})}
      cell.fill_in!
      expect(cell.value).to eq 2
    end

    it 'of 0 if there is more than 1 possible value for it' do
      cell.neighbours = [1,3,4,5,7,8,9].map{|n| double(:cell, :value => n)}
      cell.fill_in!
      expect(cell.value).to eq 0
    end
  end

end