--恩底弥翁的学者（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_SPELL,LOCATION_PZONE+LOCATION_MZONE)
	Pendulum.AddProcedure(c)
--Special Summon itself and from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetOperation(s.acop)
	c:RegisterEffect(e3)
--Opponent cannot target your monsters with card effects
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e20:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e20:SetRange(LOCATION_MZONE)
	e20:SetTargetRange(LOCATION_MZONE,0)
	e20:SetTarget(s.atktg)
	e20:SetValue(aux.tgoval)
	c:RegisterEffect(e20)
 --draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.drcon)
	e4:SetCost(s.drcost)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
--Counter check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DESTROY)
	e0:SetOperation(s.ctchk)
	e0:SetLabel(0)
	c:RegisterEffect(e0)
 --Place itself in the `Pendulum Zone when destroyed
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetLabelObject(e0)
	e5:SetCondition(s.pencon)
	e5:SetTarget(s.pentg)
	e5:SetOperation(s.penop)
	c:RegisterEffect(e5)
end
s.counter_place_list={COUNTER_SPELL}
s.listed_series={0x12a}
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,3,REASON_COST) end 
		e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,3,REASON_COST)
end
function s.cfilter(c,e,tp)
	return c:IsCanAddCounter(COUNTER_SPELL,1,false,LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_PZONE+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)<=1)
		or not c:IsRelateToEffect(e)
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(c)
	if #g>1 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==2 then
		Duel.BreakEffect()
		local ct=g:GetFirst()
		for ct in aux.Next(g) do
			ct:AddCounter(COUNTER_SPELL,1)
		end
	end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(COUNTER_SPELL,1)
	end
end
function s.atktg(e,c)
	return c:GetCounter(0x1)~=0
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,COUNTER_SPELL,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,COUNTER_SPELL,2,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.ctchk(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetCounter(COUNTER_SPELL))
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_EFFECT+REASON_BATTLE~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and (ct==0 or e:GetHandler():IsCanAddCounter(COUNTER_SPELL,ct,false,LOCATION_PZONE)) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and ct>0 then
		Duel.BreakEffect()
		c:AddCounter(COUNTER_SPELL,ct)
	end
end