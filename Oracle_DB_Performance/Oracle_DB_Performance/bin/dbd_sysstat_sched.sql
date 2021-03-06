BEGIN
DBMS_SCHEDULER.create_program (
    program_name        => 'sch_spl.dbd_sysstat_pgm',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'sch_spl.nrd_sp_sysstat',
    number_of_arguments => 1,
    enabled             => FALSE,
    comments            => 'QES splunk dashboard job - sysstat');


DBMS_SCHEDULER.define_program_argument (
                                       program_name      => 'sch_spl.dbd_sysstat_pgm',
                                       argument_name     => 'sleep_interval',
                                       argument_position => 1,
                                       argument_type     => 'NUMBER',
                                       default_value     => 300);

DBMS_SCHEDULER.ENABLE('sch_spl.dbd_sysstat_pgm');

-- Job defined by existing program and inline schedule.
  DBMS_SCHEDULER.create_job (
    job_name        => 'sch_spl.dbd_sysstat_job',
    program_name    => 'sch_spl.dbd_sysstat_pgm',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; INTERVAL=5',
    end_date        => NULL,
    enabled         => FALSE,
    comments        => 'Splunk QES Dashboard job - sysstat');

dbms_scheduler.set_attribute( name => 'DBD_SYSSTAT_JOB', attribute => 'restartable', value => FALSE);

dbms_scheduler.set_job_argument_value(job_name => 'sch_spl.dbd_sysstat_job',
                                      argument_position => 1,
                                      argument_value    => 300);
dbms_scheduler.enable(name=>'sch_spl.dbd_sysstat_job');
END;
/
