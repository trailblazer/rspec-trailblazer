require "spec_helper"

describe RSpec::Trailblazer::Reform do
  shared_examples "#validate_presence_of" do
    it { expect(album_form).to validate_presence_of(:title) }
    it { expect(album_form).to validate_presence_of(%i[title release_date], nested_collection: :songs) }
    it { expect(song_form).to validate_presence_of(:name, nested_property: :artist) }

    it "raise an error if passing the wrong option" do
      expect {
        expect(album_form).to validate_presence_of(%i[title release_date], something: :songs)
      }.to raise_error(RuntimeError, "Incorrect options passed something")
    end
  end

  context "AR validations" do
    class AlbumForm < RailsForm
      model :album

      property :title
      validates :title, presence: true

      collection :songs, populate_if_empty: Song do
        property :title
        property :release_date

        validates :title, :release_date, presence: true

        property :artist, populate_if_empty: Artist do
          property :name

          validates :name, presence: true
        end
      end
    end

    class SongForm < RailsForm
      model :song

      property :artist, populate_if_empty: Artist do
        property :name

        validates :name, presence: true
      end
    end

    let(:album_form) { AlbumForm.new(Album.new) }
    let(:song_form) { SongForm.new(Song.new) }

    it_behaves_like "#validate_presence_of"
  end

  context "dry-v" do
    class DryAlbumForm < DryVForm
      property :title

      validation do
        required(:title).filled
      end

      collection :songs, populate_if_empty: Song do
        property :title
        property :release_date

        validation do
          required(:title).filled
          required(:release_date).filled
        end

        property :artist, populate_if_empty: Artist do
          property :name

          validation do
            required(:name).filled
          end
        end
      end
    end

    class DrySongForm < DryVForm
      property :artist, populate_if_empty: Artist do
        property :name

        validation do
          required(:name).filled
        end
      end
    end

    let(:album_form) { DryAlbumForm.new(Album.new) }
    let(:song_form) { DrySongForm.new(Song.new) }

    it_behaves_like "#validate_presence_of"
  end
end
