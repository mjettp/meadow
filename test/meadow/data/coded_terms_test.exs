defmodule Meadow.Data.CodedTermsTest do
  use Meadow.DataCase
  alias Meadow.Data.CodedTerms
  import Assertions

  @schemes ["authority", "license", "marc_relator", "preservation_level",
            "rights_statement", "status", "subject_role", "visibility",
            "work_type"]

  describe "CodedTerms context" do
    test "lists schemes" do
      assert_lists_equal(@schemes, CodedTerms.list_schemes())
    end

    test "lists terms within a scheme" do
      with results <- CodedTerms.list_coded_terms("work_type") do
        assert_lists_equal(results |> Enum.map(&(&1.id)), ["AUDIO", "DOCUMENT", "IMAGE", "VIDEO"])
        assert_lists_equal(results |> Enum.map(&(&1.label)), ["Audio", "Document", "Image", "Video"])
      end
    end

    test "returns an empty term list for an unknown scheme" do
      assert CodedTerms.list_coded_terms("nope_not_here") == []
    end

    test "fetches a term by scheme and id" do
      with result <- CodedTerms.get_coded_term("cmp", "marc_relator") do
        assert result.id == "cmp"
        assert result.label == "Composer"
      end
    end

    test "returns nil for an unknown id" do
      assert CodedTerms.get_coded_term("zzz", "marc_relator") |> is_nil()
    end

    test "returns nil for an unknown scheme" do
      assert CodedTerms.get_coded_term("cmp", "nope_still_not_here") |> is_nil()
    end
  end
end
