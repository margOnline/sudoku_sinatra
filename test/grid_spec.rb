require 'grid'

describe Grid do 

  let(:puzzle) {'015003002000100906270068430490002017501040380003905000900081040860070025037204600'}
  let(:grid) {Grid.new(puzzle)}
  let(:cells) {(1..81).to_a}


  context 'initialization' do

    it 'has 81 cells' do
      expect(grid.cells.size).to eq 81
    end

    it 'has an unsolved first cell' do
      expect(grid.cells[0].value).to eq 0
    end

    it 'has a solved second cell with value 1' do
      expect(grid.cells[1].value).to eq 1
    end
  end

  it 'assigns box_ids to each cell' do
    box_id = grid.get_box_id_for(grid.cells[56])
    expect(box_id).to eql 7
  end

  context 'assigns to each cell 8 neighbours by' do
    it 'row' do
      row_neighbours = grid.get_row_neighbours_for(grid.cells[56])
      expect(row_neighbours.size).to eql 8
    end

    it 'column' do
      col_neighbours = grid.get_column_neighbours_for(grid.cells[75])
       # puts col_neighbours.inspect
      expect(col_neighbours.size).to eql 8
    end

    it 'box' do
      box_neighbours = grid.get_box_neighbours(grid.cells[75])
      # puts box_neighbours.inspect
      expect(box_neighbours.size).to eql 8
    end

  end

  it 'assigns 24 neighbours to each cell' do
    expect(grid.cells[74].neighbours.size).to eql 24
    expect(grid.cells[23].neighbours.size).to eql 24
  end

  context 'knows if it is' do

    it "not solved" do
      expect(grid.solved?).to be_false
    end

    it "solved" do
      grid.solve
      expect(grid.solved?).to be_true
      expect(grid.to_s).to eq('615493872348127956279568431496832517521746389783915264952681743864379125137254698')
    end
    
  end
 
end