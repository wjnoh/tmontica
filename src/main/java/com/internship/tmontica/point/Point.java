package com.internship.tmontica.point;

import com.internship.tmontica.point.exception.PointException;
import com.internship.tmontica.point.exception.PointExceptionType;
import lombok.*;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class Point {

    private String userId;
    private int id;
    @NotNull
    private String type;
    private Date date;
    @NotNull
    @Min(0)
    private int amount;
    private String description;

    public Point(String userId, @NotNull String type, @NotNull @Min(0) int amount, String description) {
        this.userId = userId;
        this.type = type;
        this.amount = amount;
        this.description = description;
    }

    public Point(String type, String amount){

        this.type = type;
        this.amount = Integer.parseInt(amount);
        checkPointType();
    }

    public Point(String userId, String type, String amount){

        this(type, amount);
        this.userId = userId;
    }

    public Point(String userId, String type, String amount, String description){
        this(userId, type, amount);
        this.description = description;
    }

    public String getStringAmount(){
        return String.valueOf(amount);
    }

    private void checkPointType(){

        for(PointLogType pointLogType : PointLogType.values()){

            if(pointLogType.getType().equals(type)){
                return;
            }
        }
        throw new PointException(PointExceptionType.INVALID_POINT_TYPE_EXCEPTION);
    }
}
