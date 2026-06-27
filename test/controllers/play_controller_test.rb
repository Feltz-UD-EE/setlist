require "test_helper"

class PlayControllerTest < ActionDispatch::IntegrationTest
  RemoteUploader = Struct.new(:file, :identifier) do
    def blank?
      false
    end
  end

  RemoteFile = Struct.new(:content) do
    def read
      content
    end
  end

  RemoteSheet = Struct.new(:id, :img)

  test "data uri for sheet reads remote CarrierWave file contents" do
    controller = PlayController.new
    sheet = RemoteSheet.new(
      1,
      RemoteUploader.new(RemoteFile.new("remote sheet image"), "sheet.png")
    )

    data_uri = controller.send(:data_uri_for, sheet)

    assert_match(/\Adata:image\/png;base64,/, data_uri)
    assert_equal "remote sheet image", Base64.decode64(data_uri.split(",", 2).last)
  end
end
