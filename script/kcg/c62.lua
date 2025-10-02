--CNo.39 希望皇ホープレイV
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	aux.EnableCheckRankUp(c,nil,nil,84013237)
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66970002,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	e2:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RANKUP_EFFECT)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT) 


	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetTarget(s.destg2)
	e4:SetOperation(s.desop2)
	c:RegisterEffect(e4)   
end
s.xyz_number=39
s.listed_series={0x48}
s.listed_names={84013237,6330307,1564}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.tdfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		if atk<0 or tc:IsFacedown() then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function s.filter(c,ec)
	return c:GetEquipTarget()==ec
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,e:GetHandler()) and eg:IsExists(Card.IsCode,1,nil,6330307) end
	local dg=eg:Filter(s.filter,nil,e:GetHandler())
	e:SetLabelObject(dg)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local c=e:GetHandler()
	local code1=0
	local code0=0
	for tc in aux.Next(tg) do
		if tc:IsCode(6330307) then code1=1564 code0=6330307 end
	end

	if code1==0 then return end
	-- local e8 = Effect.CreateEffect(c)
	-- e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e8:SetCode(EVENT_LEAVE_FIELD_P)
	-- e8:SetRange(LOCATION_MZONE)
	-- e8:SetOperation(s.recover)
	-- e8:SetReset(RESET_EVENT + 0x1fe0000)
	-- e8:SetLabel(code0)
	-- c:RegisterEffect(e8, true)
	-- local e9 = Effect.CreateEffect(c)
	-- e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e9:SetCode(EVENT_LEAVE_FIELD_P)
	-- e9:SetOperation(s.recover2)
	-- e9:SetReset(RESET_EVENT+0x1fe0000)
	-- c:RegisterEffect(e9, true)
	c:SetEntityCode(code1,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,EFFECT_FLAG_CANNOT_DISABLE,RESET_EVENT+RESETS_STANDARD,c,true)
	aux.CopyCardTable(code1,c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
-- function s.filter2(c,ec,code)
-- 	return c:GetEquipTarget()==ec and c:IsCode(code)
-- end
-- function s.recover(e,tp,eg,ep,ev,re,r,rp)
-- 	local code=e:GetLabel()
-- 	local c=e:GetHandler()
-- 	local eqg=c:GetEquipGroup()
-- 	eqg:Sub(eg)
-- 	if eg:IsExists(s.filter2,1,nil,c,code) and not eqg:IsExists(Card.IsCode,1,c,code) and not c:IsOriginalCode(id) then
-- 		c:SetEntityCode(id,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
-- 		aux.CopyCardTable(id,c)
-- 	end
-- end
-- function s.recover2(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	if not c:IsOriginalCode(id) then
-- 		c:SetEntityCode(id,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
-- 		aux.CopyCardTable(id,c)
-- 	end
-- end