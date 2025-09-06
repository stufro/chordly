require "rails_helper"

describe ChordProConverter do
  let(:raw_content) do
    <<~TEXT
      {title: You Are My Sunshine}

      {c:Verse 1}
      [G]The other night dear as I lay sleeping
      [G7]I dreamed I [C]held you in my [G]arms
      [G7]But when I a[C]woke dear I was mis[G]taken
      So I hung my [D7]head and [G]cried

      {c:Chorus}
      {soc}
      You are my sunshine my only sunshine
      [G7]You make me [C]happy when skies are [G]gray
      [G7]You'll never [C]know dear how much I [G]love you
      Please don't take [D7]my sunshine a[G]way
      {eoc}
    TEXT
  end

  describe "#title" do
    it "returns the title of the song" do
      expect(described_class.new(raw_content).title).to eq("You Are My Sunshine")
    end
  end

  describe "#body" do
    it "returns the chord sheet string modelled as JSON" do
      expect(described_class.new(raw_content).body).to eq(
        <<~TEXT.strip
          [Verse 1]
          G
          The other night dear as I lay sleeping
          G7          C              G
          I dreamed I held you in my arms
          G7          C                  G
          But when I awoke dear I was mistaken
                       D7       G
          So I hung my head and cried


          [Chorus]
          You are my sunshine my only sunshine
          G7          C                    G
          You make me happy when skies are gray
          G7           C                    G
          You'll never know dear how much I love you
                            D7           G
          Please don't take my sunshine away
        TEXT
      )
    end
  end
end
