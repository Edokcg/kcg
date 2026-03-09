--Dark Necrofear (Anime)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	--e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	
	--reg
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.eqcon)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
end
s.listed_names={16625614}

function s.spfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and #rg>2 and aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.filter(c)
	return c:IsCode(16625614)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (r&REASON_DESTROY)~=0 then
		c:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
	end
end

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.CheckStealEquip(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,aux.CheckStealEquip,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and aux.CheckStealEquip(tc,e,tp) and tc:IsRelateToEffect(e) and Duel.Equip(tp,c,tc) then
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
		c:RegisterEffect(e2)
	end
end