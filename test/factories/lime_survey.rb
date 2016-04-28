FactoryGirl.define do
  factory :lime_survey do
    sequence(:sid) { |n| n + 12345}                
    owner_id 1                        
    active 'N'                       
    adminemail { Faker::Internet.email }              
    anonymized 'Y'                         
    format 'G'    
    savetimings 'Y'                         
    template 'default'                  
    language 'en'                     
    datestamp 'Y'                      
    usecookie 'Y'                      
    allowregister 'Y'                      
    allowsave 'Y'

    trait(:with_tables) do
      active 'Y'
      after(:create) do |survey|
        create_min_survey(survey.sid)
      end
      
      trait(:with_response) do
        after(:create) do |survey|
          create_min_response(survey.sid)
        end
      end
    end
  end
end


def create_min_response sid = 12345, opts={}
  topts = opts[:tokens] || {}
  topts[:firstname] ||= :fname
  topts[:lastname] ||= :lname
  topts[:email] ||= 'test@example.com'
  topts[:token] ||= :atoken11
  topts[:language] ||= :en
  topts[:attribute_1] ||= :attr_1
  topts[:attribute_2] ||= :attr_2

  ropts = opts[:response] || {}
  ropts[:token] ||= :atoken11
  ropts[:submitdate] ||= '2015-08-08'
  ropts[:lastpage] ||= 3
  ropts[:startlanguage] ||= 'en'
  ropts[:col1] ||= '34.000'
  ropts[:col2] ||= '2014-07-07'
  ropts[:col3] ||= 1
  ropts[:col4] ||= 'TestQuestion'
  query = "
    INSERT INTO #{LimeExt.table_prefix}_survey_#{sid}
    (token, submitdate, lastpage, startlanguage,
      \"#{sid}X123X6036\",
      \"#{sid}X123X6037\",
      \"#{sid}X123X6038\",
      \"#{sid}X123X6039\")
    VALUES('#{ropts[:token]}', '#{ropts[:submitdate]}', #{ropts[:lastpage]},
        '#{ropts[:startlanguage]}', '#{ropts[:col1]}', '#{ropts[:col2]}',
        #{ropts[:col3]}, '#{ropts[:col4]}');

    INSERT INTO #{LimeExt.table_prefix}_tokens_#{sid} (
      firstname, lastname, email, token, language, attribute_1, attribute_2
    )VALUES('#{topts[:firstname]}', '#{topts[:lastname]}', '#{topts[:email]}',
      '#{topts[:token]}', '#{topts[:language]}', '#{topts[:attribute_1]}', '#{topts[:attribute_2]}');
  "
  ActiveRecord::Base.connection.execute(query)
end


def create_min_survey sid = 12345
  query = "
  CREATE SEQUENCE #{LimeExt.table_prefix}_survey_#{sid}_id_seq1
      START WITH 1
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      CACHE 1;

  --
  -- Name: lime_survey_#{sid}; Type: TABLE; Schema: public;
  --

  CREATE TABLE #{LimeExt.table_prefix}_survey_#{sid} (
      id integer NOT NULL DEFAULT nextval('#{LimeExt.table_prefix}_survey_#{sid}_id_seq1'),
      token character varying(36),
      submitdate timestamp without time zone,
      lastpage integer,
      startlanguage character varying(20) NOT NULL,
      \"#{sid}X123X6036\" numeric(30,10),
      \"#{sid}X123X6037\" timestamp without time zone,
      \"#{sid}X123X6038\" character varying(1),
      \"#{sid}X123X6039\" character varying(255)
  );


  CREATE SEQUENCE #{LimeExt.table_prefix}_tokens_#{sid}_tid_seq
      START WITH 1
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      CACHE 1;

  --
  -- Name: lime_tokens_#{sid}; Type: TABLE; Schema: public; Owner: sa; Tablespace:
  --

  CREATE TABLE #{LimeExt.table_prefix}_tokens_#{sid} (
    tid integer NOT NULL DEFAULT nextval('#{LimeExt.table_prefix}_tokens_#{sid}_tid_seq'),
    participant_id character varying(50),
    firstname character varying(40),
    lastname character varying(40),
    email text,
    emailstatus text,
    token character varying(35),
    language character varying(25),
    blacklisted character varying(17),
    sent character varying(17) DEFAULT 'N'::character varying,
    remindersent character varying(17) DEFAULT 'N'::character varying,
    remindercount integer DEFAULT 0,
    completed character varying(17) DEFAULT 'N'::character varying,
    usesleft integer DEFAULT 1,
    validfrom timestamp without time zone,
    validuntil timestamp without time zone,
    mpid integer,
    attribute_1 character varying(255),
    attribute_2 character varying(255)
  );


  --
  -- Name: #{LimeExt.table_prefix}_tokens_#{sid}_pkey; Type: CONSTRAINT; Schema: public; Owner: sa; Tablespace:
  --

  ALTER TABLE ONLY #{LimeExt.table_prefix}_tokens_#{sid}
    ADD CONSTRAINT #{LimeExt.table_prefix}_tokens_#{sid}_pkey PRIMARY KEY (tid);

  --
  -- Name: idx_token_token_#{sid}_18071; Type: INDEX; Schema: public; Owner: sa; Tablespace:
  --

  CREATE INDEX idx_token_token_#{sid}_18071 ON #{LimeExt.table_prefix}_tokens_#{sid} USING btree (token);

  "
  ActiveRecord::Base.connection.execute(query)
end

