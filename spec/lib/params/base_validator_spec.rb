# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Params::BaseValidator do
  let(:validator) { described_class.new({}) }

  describe '#email_format' do
    it 'when email is valid' do
      emails = [
        '  john.doe@example.com  ',
        'john.doe@example.com',
        'jane+newsletter@domain.org',
        'mike_smith@company.net',
        'lisa-wong@sub.example.co.uk',
        'peter@webmail.com',
        'anna.jones123@my-domain.com',
        'contact@company.email',
        'info@my-company123.org',
        'hello.world@business.info',
        'feedback@new-domain.com',
        'alerts+user@localdomain.net',
        'webmaster@industry.biz',
        'services@agency.example',
        'george123@consultant.pro',
        'sales-team@company.io'
      ]

      emails.each do |email|
        expect { validator.email_format({ email: }, :email) }.not_to raise_error
      end
    end

    it 'when signle email is invalid' do
      emails = [
        'jone.doe@',
        'mike.smith@',
        'jane.doe@@example.com',
        '@example.com',
        'lisa.wong@example',
        'peter.parker..@example.com',
        'anna.jones@.com',
        'jack.brown@com',
        'john doe@example.com',
        'laura.martin@ example.com',
        'dave.clark@example .com',
        'susan.green@example,com',
        'chris.lee@example;com',
        'jenny.king@.example.com',
        '.henry.ford@example.com',
        'amy.baker@sub_domain.com',
        'george.morris@-example.com',
        'nancy.davis@example..com',
        'kevin.white@.',
        'diana.robinson@.example..com',
        'oliver.scott@example.c',
        'email1@g.comemail@g.com',
        'user.name@subdomain.example@example.com',
        'double@at@sign.com',
        'user@@example.com',
        'email@123.123.123.123',
        'this...is@strange.but.valid.com',
        'mix-and.match@strangely-formed-email_address.com',
        'email@domain..com',
        'user@-weird-domain-.com',
        'user.name@[IPv6:2001:db8::1]',
        'tricky.email@sub.example-.com',
        'user@domain.c0m'
      ]

      emails.each do |email|
        expect do
          validator.email_format({ email: }, :email)
        end.to raise_error(described_class::InvalidParameterError, 'email must follow the email format')
      end
    end

    it 'when multiple emails are valid' do
      emails = [

        'john.doe@example.com, jane.doe+newsletter@domain.org',
        'joshua@automobile.car ; chloe+fashion@food.delivery',
        'mike-smith@company.net;lisa.wong-sales@sub.example.co.uk',
        'peter.parker+info@webmail.com,laura.martin-office@company.co',
        'anna.jones123@my-domain.com, jack.brown+work@college.edu',
        'susan.green@business-info.org; dave.clark+personal@nonprofit.org',
        'chris.lee+team@new-domain.com;jenny.king.marketing@localdomain.net',
        'george.morris@consultant.pro; nancy.davis-office@company.io',
        'joshua-jones@automobile.car; chloe.taylor+fashion@food.delivery',
        'ryan.moore+alerts@music-band.com,isabella.walker.design@fashion.design',
        'support-team@company.com, contact.us@domain.org',
        'admin.office@industry.biz, hr.department@service.pro',
        'feedback@agency-example.org; hello.world@creative-studio.net',
        'sales-team@e-commerce.shop, support.department@technology.co',
        'media.contact@financial.servicesl; events-coordinator@food.delivery',
        'order@music-band.com; info.support@creative.example',
        'design.team@webmail.com , admin-office@company.co',
        'contact.sales@sub-example.co.uk, support+info@legal.gov',
        'support@media.group;subscribe-updates@concert.events'
      ]

      emails.each do |email|
        expect { validator.email_format({ email: }, :email) }.not_to raise_error
      end
    end

    it 'when multiple emails are invalid' do
      emails = [
        'jone@gmail.com, ,mike@gmail.com',
        'john.doe@example.com  dave@nonprofit.org',
        '; oliver.scott@example.com',
        'amy.baker@ example.com, george.morris@ example.com',
        'jenny.king@example.com . diana.robinson@example.com',
        'nancy.davis@.com, henry.ford@.com',
        'jack.brown@example.com, laura.martin@example .com',
        'anna.jones@example,com lisa.wong@example.com',
        'dave.clark@example.com kevin.white@example;com',
        'susan.green@ example.com; john.doe@example.com',
        'amy.baker@sub_domain.com george.morris@-example.com',
        'nancy.davis@example..com john.doe@example.c',
        'peter.parker@example.com, .henry.ford@example.com',
        'diana.robinson@.example..com, mike.smith@.',
        'oliver.scott@example.com; laura.martin@ example.com, jane.doe@@example.com'
      ]

      emails.each do |email|
        expect do
          validator.email_format({ email: }, :email)
        end.to raise_error(described_class::InvalidParameterError, 'email must follow the email format')
      end
    end

    it 'when email is invalid with custom message' do
      expect do
        validator.email_format({ email: 'jone.doe@' }, :email, message: 'email is invalid')
      end.to raise_error(described_class::InvalidParameterError, 'email is invalid')
    end
  end
end
