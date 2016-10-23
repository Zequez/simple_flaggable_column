describe SimpleFlaggableColumn do
  before :all do
    class Migration < ActiveRecord::Migration[5.0]
      def change
        create_table :games do |t|
          t.integer :platforms, default: 0, null: false
        end
      end
    end

    Migration.new.migrate(:up)

    class Game < ActiveRecord::Base
      include SimpleFlaggableColumn

      flag_column :platforms, {
        win:   0b001,
        mac:   0b010,
        linux: 0b100
      }
    end
  end

  it 'should be empty by default' do
    expect(Game.new.platforms).to eq []
  end

  it 'should let you save data' do
    game = Game.new
    game.platforms = [:mac, :linux]
    expect(game.read_attribute(:platforms)).to eq 0b110
    expect(game.platforms).to match_array [:mac, :linux]
  end

  it "should ignore items that aren't on the list" do
    game = Game.new
    game.platforms = [:mac, :linux, :potato]
    expect(game.read_attribute(:platforms)).to eq 0b110
    expect(game.platforms).to match_array [:mac, :linux]
  end

  it 'should set the value to 0 when nil' do
    game = Game.new
    game.platforms = [:mac, :linux]
    expect(game.platforms).to eq [:mac, :linux]
    game.platforms = nil
    expect(game.platforms).to eq []
  end

  it 'should allow you to set numeric values directly' do
    game = Game.new
    game.platforms = 0b101
    expect(game.platforms).to eq [:win, :linux]
  end

  describe 'flags lists' do
    it 'should define the list of flags' do
      expect(Game.platforms_flags).to eq({
        win:   0b001,
        mac:   0b010,
        linux: 0b100
      })
    end

    it 'should let you get a join list of flags' do
      expect(Game.platforms_flags(:win, :linux)).to eq 0b101
    end

    it 'should define the reverse list of flags' do
      expect(Game.flags_platforms).to eq({
        0b001 => :win,
        0b010 => :mac,
        0b100 => :linux
      })
    end
  end
end
