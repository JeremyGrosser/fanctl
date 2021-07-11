with Controller;

procedure Main is
begin
   Controller.Initialize;
   loop
      Controller.Tick;
   end loop;
end Main;
