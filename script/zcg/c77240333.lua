--上古亡灵称(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	   c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.limfilter),LOCATION_SZONE)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
  --guess
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
   --remain field
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e9)
end
function s.limfilter(c)
return c:IsCode(77240324) or c:IsCode(77240329) or c:IsCode(77240330) or c:IsCode(77240331) or c:IsCode(77240332) or c:IsCode(77240333) or c:IsCode(77240334)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local time=1
	aType772403331=nil
	aType772403332=nil
	aType772403333=nil
	while time<=3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		_G["aType77240333"..time]=Duel.AnnounceType(1-tp)
		time=time+1
	end
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if #g<3 then return false end
	local res=true
	local time2=1
	local tc=g:GetFirst()
	while tc and time2<=3 do
		if (tc:IsType(TYPE_MONSTER) and _G["aType77240333"..time2]==0) or (tc:IsType(TYPE_SPELL) and _G["aType77240333"..time2]==1) or
			(tc:IsType(TYPE_TRAP) and _G["aType77240333"..time2]==2) then
			res=false
		else
			res=true 
			break
		end
		tc=g:GetNext()
		time2=time2+1
	end
	if res==true then
		 local hg=g:Filter(Card.IsAbleToHand,nil)
		if #hg>0 then
			Duel.SendtoHand(hg,tp,REASON_EFFECT)
		 end
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE) 
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	s[e:GetHandler()]=e1
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(1082946)
	end
end
