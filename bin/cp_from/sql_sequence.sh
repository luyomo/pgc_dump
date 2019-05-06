set session "db.db" to :db;
set session "db.ver" to :ver;

\copy (select string_agg(seq,' union ') from (select 'select '''||current_setting('db.db')||''','''||current_setting('db.ver')||''','||c.relfilenode||',20, s.start_value,s.increment_by,s.max_value,s.min_value,s.cache_value,s.is_cycled from '|| pn.nspname||'.'||c.relname||' s' as seq from pg_class c left join pg_namespace pn on pn.oid = c.relnamespace where  c.relkind='S') a) to '/tmp/sql_sequence.sql';
