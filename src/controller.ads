with Units; use Units;

package Controller is

   procedure Initialize;
   procedure Run;

private

   function Target_Speed
      return RPM;

end Controller;
