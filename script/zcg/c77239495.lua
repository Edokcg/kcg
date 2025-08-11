--火神龙·骑玛利欧斯
function c77239495.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--Fusion.AddProcCode3(c,80019195,85800949,84565800,true,true)
	
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c77239495.con)
	c:RegisterEffect(e1)

	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c77239495.efilter)
	c:RegisterEffect(e2)
	
	--Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c77239495.target)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e3)
	
	--effect draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(2)
	c:RegisterEffect(e4)
end
---------------------------------------------------------------------
function c77239495.con(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
---------------------------------------------------------------------
function c77239495.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end
---------------------------------------------------------------------
function c77239495.target(e,c)
	return c:IsFaceup()
end
---------------------------------------------------------------------
--[[function c77239495.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(Duel.GetDrawCount(tp)+1)
	Duel.RegisterEffect(e1,tp)
end]]

