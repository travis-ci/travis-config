describe Travis::Config::Serialize::Env do
  let(:config) do
    {
      foo: { bar: :baz },
      true: true,
      false: false,
      nil: nil
    }
  end

  subject { described_class.new(config, prefix: 'travis').apply }

  it { should include 'TRAVIS_FOO_BAR=baz' }
  it { should include 'TRAVIS_TRUE=true' }
  it { should include 'TRAVIS_FALSE=false' }
  it { should_not include 'TRAVIS_NIL=' }
end
