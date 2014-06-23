require 'spec_helper'

describe BitVault::Payment do

  describe '#sign' do 
    let(:transaction) { double('transaction', base58_hash: base58_hash, outputs: []) }
    let(:unsigned_payment) { double('unsigned_payment', sign: signed_payment) }
    let(:signed_payment) { double('signed_payment') }
    let(:signatures) { double('signatures') }
    let(:base58_hash) { 'abcdef123456' }
    let(:payment) { BitVault::Payment.new(resource: unsigned_payment) }
    let(:wallet) { double('wallet', signatures: signatures, valid_output?: true) }

    before(:each) {
      allow(CoinOp::Bit::Transaction).to receive(:data) { transaction }
    }

    context 'with invalid change address' do
      before(:each) { 
        allow(wallet).to receive(:valid_output?).and_return(false) 
      }
      
      it 'raises an error' do
        expect { payment.sign(wallet) }.to raise_error(RuntimeError)
      end
    end

    context 'with no wallet' do
      it 'raises an error' do
        expect { payment.sign(nil) }.to raise_error(RuntimeError)
      end
    end

    context 'with valid inputs' do
      it 'calls sign on the resource' do
        expect(unsigned_payment).to receive(:sign).with(
          transaction_hash: base58_hash,
          inputs: signatures)
        payment.sign(wallet)
      end

      it 'sets the resource to the signed_payment' do
        payment.sign(wallet)
        expect(payment.resource).to eql(signed_payment)
      end
    end

  end
end