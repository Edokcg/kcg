--機皇帝ワイゼル∞
local s, id = GetID()
function s.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(s.operation)
	c:RegisterEffect(e1)
	--defup
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.operation1)
	c:RegisterEffect(e2)
	--cannot be target
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_SINGLE)
	-- e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	-- e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetValue(s.efr)
	--c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000050,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)
	  local e10=Effect.CreateEffect(c)
	  e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	  e10:SetCode(EVENT_DESTROYED)
	  e10:SetCategory(CATEGORY_DESTROY)
	  e10:SetCondition(s.descon2)
	  e10:SetTarget(s.destg)
	  e10:SetOperation(s.desop)
	  c:RegisterEffect(e10)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_ATTACK)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(s.atkfilter)
	c:RegisterEffect(e9)	
end
s.collection={
	[39648965]=true;[68140974]=true; --Wisel
	[75733063]=true;[31930787]=true; --Skiel
	[2137678]=true;[4545683]=true; --Granel
}
function s.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x300) or s.collection[c:GetCode()])
end
function s.eqfilter2(c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_SYNCHRO)~=0
end
function s.operation1(e,c)
	local wup=0
	local wg=Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,0,c)
	local wbc=wg:GetFirst()
	while wbc do
		wup=wup+wbc:GetAttack()
		wbc=wg:GetNext()
	end

	  local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter2,nil)
	  local tatk=0
	  if g:GetCount()>0 then
	  local tc=g:GetFirst()
	  while tc do
	  local atk=tc:GetTextAttack()
	  tatk=tatk+atk
	  tc=g:GetNext() end end

	return wup+tatk
end

function s.operation(e,c)
	local wup=0
	local wg=Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,0,c)
	local wbc=wg:GetFirst()
	while wbc do
		wup=wup+wbc:GetAttack()
		wbc=wg:GetNext()
	end
	return wup
end

function s.efr(e,re)
	return re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				--tc:RegisterEffect(e2)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end

function s.exfilter(c,fid)
	return c:IsFaceup() and c:IsSetCard(0x3013) and (fid==nil or c:GetFieldID()<fid)
end
function s.excon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.splimit(e,se,sp,st,spos,tgp)
	if bit.band(spos,POS_FACEDOWN)~=0 then return true end
	return not Duel.IsExistingMatchingCard(s.exfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function s.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil,c:GetFieldID())
end

function s.descon2(e)
	local c=e:GetHandler()
	return c:GetPreviousLocation()==LOCATION_ONFIELD and c:GetPreviousPosition()==POS_FACEUP
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,nil,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function s.atkfilter(e,c)
	return c~=e:GetHandler() 
end
