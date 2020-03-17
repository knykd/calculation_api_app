require 'rails_helper'

RSpec.describe 'MakingBignum', type: :request do
  describe 'GET /making_bignum' do
    context 'パラメータが正しい場合' do
      it 'ステータス200を返すこと' do
        get '/making_bignum' + '?3,20,9'
        expect(response).to have_http_status(200)
      end
    end

    context '4,9,5,7の場合(同じ桁の数値のみ)' do
      it '9754を返すこと' do
        get '/making_bignum' + '?4,9,5,7'
        json = JSON.parse(response.body)
        expect(json['data']).to eq '9754'
      end
    end

    context '3,30,34,5,9の場合(桁が違う数値がある)' do
      it '9534303を返すこと' do
        get '/making_bignum' + '?3,30,34,5,9'
        json = JSON.parse(response.body)
        expect(json['data']).to eq '9534330'
      end
    end

    context '3,241,320,4,241の場合(同じ数値がある)' do
      it '43320241241を返すこと' do
        get '/making_bignum' + '?3,241,320,4,241'
        json = JSON.parse(response.body)
        expect(json['data']).to eq '43320241241'
      end
    end

    context 'パラメータが正しくない場合' do
      it 'ステータス400を返すこと' do
        get '/making_bignum'
        expect(response).to have_http_status(400)
      end
    end
  end
end
