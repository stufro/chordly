module ChordDiagramHelper
  def positions(chord)
    diagram = chord_collection[chord]
    return unless diagram

    diagram.first["positions"].join
  end

  def fingerings(chord)
    diagram = chord_collection[chord]
    return unless diagram

    diagram.first["fingerings"].join
  end

  def chord_collection
    @chord_collection ||= JSON.parse(Rails.root.join("files/chord_collection.json").read)
  end
end
