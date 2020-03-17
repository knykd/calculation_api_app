require 'rails_helper'

RSpec.describe 'Most', type: :request do
  describe 'GET /most' do
    context 'パラメータが正しい場合' do
      it 'ステータス200を返すこと' do
        get '/most' + '?Zza'
        expect(response).to have_http_status(200)
      end
    end

    context 'aの場合(アルファベット一文字)' do
      it 'Aを返すこと' do
        get '/most' + '?a'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'A'
      end
    end

    context 'Mississipiの場合(出現回数が同じアルファベットがある)' do
      it 'I,Sを返すこと' do
        get '/most' + '?Mississipi'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'I,S'
      end
    end

    context 'bdcDawWLVIadDQaldRawifdfvuDwDwIqjgqadzcDdaPOの場合(アルファベットが複数ある)' do
      it 'Dを返すこと' do
        get '/most' + '?bdcDawWLVIadDQaldRawifdfvuDwDwIqjgqadzcDdaPO'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'D'
      end
    end

    context 'パラメータが正しくない場合' do
      it 'ステータス400を返すこと' do
        get '/most'
        expect(response).to have_http_status(400)
      end
    end
  end
end
