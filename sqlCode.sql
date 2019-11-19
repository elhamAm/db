SET SERVEROUTPUT ON; 
/*changer 10 et 12*/
--exo1

declare 
 temp10 employees.salary%TYPE;
 temp12 employees.salary%TYPE;

 begin 
    select salary
    into temp10
    from employees
    where employees.employee_ID = 10;
    
    select salary
    into temp12
    from employees
    where employees.employee_ID = 12;
    
    update employees set employees.salary = temp12 where employee_ID = 10;
    update employees set employees.salary = temp10 where employee_ID = 12;
    
    
 end;
 
 
 --exo2
 declare 
 n_employe employees.employee_ID%type:=&numero_employe;
 salarySelected employees.salary%type;
 datehired date;
 
 begin
 
    select salary 
    into salarySelected
    from employees
    where employees.employee_ID =  n_employe;
    /*
    select ADD_MONTHS(year , hire_date, GETDATE())
    into   experience
    from  employees
    where employees.employee_ID =  n_employe;*/

    select hire_date
    into   datehired
    from  employees
    where employees.employee_ID =  n_employe;


    if salarySelected > 10000 THEN
        update employees set employees.commission_pct = 0.4 where employee_ID = n_employe;
    elsif salarySelected < 10000 and datehired < ADD_MONTHS(SYSDATE, -(10 * 12)) THEN
        update employees set employees.commission_pct = 0.35 where employee_ID = n_employe;
    elsif salarySelected < 3000 THEN
        update employees set employees.commission_pct = 0.25 where employee_ID = n_employe;
    else 
        update employees set employees.commission_pct = 0.15 where employee_ID = n_employe;

    end if;

 end;

 --exo3
 
declare
    lastname employees.last_name%type := '&lastname_employe';
    firstname employees.first_name%type := '&firstname_employe';
    nombre int := 0;
    rowSelected employees%ROWTYPE;
begin
    select count(*)
    into nombre
    from employees
    where lastname = employees.last_name;

  
    
       if nombre> 0 THEN
            
            select *
            into rowSelected
            from employees
            where lastname = last_name;
            
            dbms_output.put_line('Cet employé existe déjà');
            dbms_output.put_line('Employee_ID:'|| rowSelected.employee_ID|| chr(10)||
            'first name:'|| rowSelected.first_name|| chr(10)||
            'last name: ' || rowSelected.last_name||chr(10)||
            'email: '|| rowSelected.email||chr(10)||
            'phonenumber: '||rowSelected.phone_number|| chr(10)||
            'hire date:' || rowSelected.hire_date||chr(10)||
            'job_id: ' || rowSelected.job_ID||chr(10)||
            'salary: '||rowSelected.salary||chr(10)||
            'commision: '||rowSelected.commission_pct||chr(10)||
            'manager_ID: '||rowSelected.manager_ID||chr(10)||
            'department_ID: '||rowSelected.department_ID);
            
        else
            insert into employees values(30,lastname,firstname,null,null,null,0001,008000.00,0.8,0007,0003);
     
       end if;
    

 end;
 

  --exo4
 declare
 hireDate NUMBER(10);
 monthlyRecrus NUMBER(4);
 begin
    select extract(year from hire_date)
    into hireDate
    from employees
    group by extract(year from hire_date)
    having count(*)= (select max(count(*)) 
                                from employees
                                group by extract(year from hire_date));
                                
     dbms_output.put_line('lannee avec le plus de recrus: '||hireDate);
     
     for index_month in 1..12
     LOOP
        select count(*)
        into monthlyRecrus
        from employees
        where extract(year from hire_date) = hireDate and extract(month from hire_date) = index_month;
        
        dbms_output.put_line('month '||index_month||': '||monthlyRecrus);
     end loop;
     
    
    
end; 
 
 