require "helper"

class AbbeyTest < Test::Unit::TestCase

  def setup
    @settings = Abbey::Settings.new('/tmp/abbey', [:ns1, :ns2], Logger.new(STDOUT))
    @abbey = Abbey::EntityStorage.new(@settings)
  end

  def teardown
    FileUtils.rm_r('/tmp/abbey') if Dir.exist?('/tmp/abbey')
  end

  def test_it_will_check_for_readiness
    assert !@abbey.set_up?
    FileUtils.mkdir_p('/tmp/abbey/ns1')
    FileUtils.mkdir('/tmp/abbey/ns2')
    assert Dir.exists?('/tmp/abbey/ns1')
    assert @abbey.set_up?

  end

  def test_it_will_create_directories
    assert !@abbey.set_up?
    @abbey.set_up!
    assert @abbey.set_up?
  end

  def test_it_will_save_data
    @abbey.set_up!
    data = {"a" => "some string, man", "b" => [1, 2, 3]}
    @abbey.save(:ns1, :key, data)
    assert_equal data, @abbey.get(:ns1, :key)
  end

  def test_it_wont_accept_bad_ns
    @abbey.set_up!
    begin
      @abbey.save(:bullshit, :key, {})
      assert false, "Errno::ENOENT not thrown"
    rescue Errno::ENOENT
    end
  end

  def test_exists_works
    @abbey.set_up!
    @abbey.save(:ns1, :key, {})
    assert @abbey.exists?(:ns1, :key)
    assert !@abbey.exists?(:ns1, :bleeee)
  end

  def test_it_deletes_items
    @abbey.set_up!
    @abbey.save(:ns1, :key, {})
    assert @abbey.exists?(:ns1, :key)
    @abbey.delete(:ns1, :key)
    assert !@abbey.exists?(:ns1, :key)
  end

  def test_it_lists_items
    @abbey.set_up!
    @abbey.save(:ns1, :key, {:a => :b})
    @abbey.save(:ns1, :key2, ["a"])
    assert_equal Set.new([:key, :key2]), @abbey.list(:ns1)
  end

  def test_it_gets_all_items
    @abbey.set_up!
    @abbey.save(:ns1, :key, {"a" => 1})
    @abbey.save(:ns1, :key2, %w{a b c})
    assert_equal({:key => {"a" => 1}, :key2 => %w{a b c}}, @abbey.get_all(:ns1))
  end

  def test_it_updates_items
    @abbey.set_up!
    @abbey.save(:ns1, :key, {"a" => 1})
    @abbey.update(:ns1, :key, {"a" => 2})
    assert_equal({"a" => 2}, @abbey.get(:ns1,:key))
  end

  def test_it_will_drop_items
    @abbey.set_up!
    @abbey.save(:ns1, :key, {"a" => 1})
    @abbey.save(:ns1, :key2, {"a" => 2})
    @abbey.save(:ns2, :key, {"a" => 2})
    @abbey.drop(:ns1)
    assert_equal(Set.new, @abbey.list(:ns1))
    assert_equal Set.new([:key]), @abbey.list(:ns2)
  end

  def test_special_chars_in_keys
    @abbey.set_up!
    @abbey.save(:ns1, "with:colon", {"a" => 1})
    assert_equal ({"a" => 1}), @abbey.get(:ns1, "with:colon")
    assert_raise Abbey::InvalidNameError do
      @abbey.save(:ns1, "with/slash", {"a" => 5})
    end
  end

  def test_special_chars_in_namespaces
    abbey = Abbey::EntityStorage.new(Abbey::Settings.new('/tmp/abbey', [:ns1, :"with:colon"], Logger.new(STDOUT)))
    abbey.set_up!
    abbey.save("with:colon", :key, ["datadata"])
    assert_equal ["datadata"], abbey.get("with:colon", :key)
  end

end