# frozen_string_literal: true

require_relative 'sobmedidaplanejados/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'

module Sobmedidaplanejados
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        }
      ]
    end

    class F1SalesCustom::Email::Parser
      def parse
        {
          source: source,
          customer: customer,
          product: product,
          description: lead_description
        }
      end

      def parsed_email
        @email.body.colons_to_hash(/(#{regular_expression}).*?\ /, false)
      end

      def regular_expression
        'Nome|Telefone|Qual ambiente você deseja mobiliar|Por qual loja deseja ser atendido|
        |Qual pretensão de investimento'
      end

      def source
        {
          name: F1SalesCustom::Email::Source.all[0][:name]
        }
      end

      def customer
        {
          name: customer_name,
          phone: customer_phone,
          email: customer_email
        }
      end

      def customer_name
        parsed_email['nome']
      end

      def customer_phone
        parsed_email['telefone']&.gsub(/\D/, '')
      end

      def customer_email
        ''
      end

      def lead_description
        "Ambiente: #{living_space}; Loja: #{store}; Pretensão de investimento: #{price_intention}"
      end

      def product
        {
          name: ''
        }
      end

      def living_space
        parsed_email['qual_ambiente_voc_deseja_mobiliar']
      end

      def store
        parsed_email['por_qual_loja_deseja_ser_atendido']
      end

      def price_intention
        parsed_email['qual_pretenso_de_investimento'].split("\n").first
      end
    end
  end
end
