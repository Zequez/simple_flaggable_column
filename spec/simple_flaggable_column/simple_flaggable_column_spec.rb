describe SimpleFlaggableColumn do
  before :all do
    class Migration < ActiveRecord::Migration[5.0]
      def change
        create_table :games do |t|
          t.integer :platforms, default: 0, null: false
          t.integer :softie, default: 0, null: false
        end
      end
    end

    Migration.new.migrate(:up)

    class Game < ActiveRecord::Base
      include SimpleFlaggableColumn

      flag_column :platforms, {
        win:   0b1,
        mac:   0b10,
        linux: 0b100
      }

      flag_column :softie, {
        vanilla:   0b1,
        chocolate: 0b10
      }, throw_on_missing: false
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

  context 'with throw_on_missing set to false' do
    it 'should throw an exception when setting a non-existing flags' do
      game = Game.new
      expect{ game.platforms = [:potato] }.to raise_error ArgumentError
    end
  end

  context 'with throw_on_missing set to true' do
    it 'should not throw an exception when setting a non-existant flags' do
      game = Game.new
      expect{ game.softie = [:chocolate, :potato] }.to_not raise_error
      expect(game.read_attribute(:softie)).to eq 0b10
      expect(game.softie).to match_array [:chocolate]
    end
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
