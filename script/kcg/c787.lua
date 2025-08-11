--CXyz Barian, the King of Wishes
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3,nil,nil,Xyz.InfiniteMats)
	c:EnableReviveLimit()

	--special summon 
	-- local e00=Effect.CreateEffect(c)  
	-- e00:SetType(EFFECT_TYPE_FIELD) 
	-- e00:SetCode(EFFECT_SPSUMMON_PROC)  
	-- e00:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	-- e00:SetRange(LOCATION_EXTRA)  
	-- e00:SetCondition(s.spcon)  
	-- e00:SetOperation(s.spop)  
	-- e00:SetValue(SUMMON_TYPE_XYZ)
	-- c:RegisterEffect(e00)  

	--atk
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCode(EFFECT_SET_ATTACK)
	-- e2:SetValue(s.atkval)
	-- c:RegisterEffect(e2)

	local e33=Effect.CreateEffect(c)
	e33:SetDescription(aux.Stringid(13718,10))
	e33:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e33:SetType(EFFECT_TYPE_IGNITION)
	e33:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e33:SetRange(LOCATION_MZONE)
	e33:SetCountLimit(1)
	e33:SetCost(s.c101cost)
	e33:SetTarget(s.c101target2)
	e33:SetOperation(s.c101operation2)
	c:RegisterEffect(e33,false,EFFECT_MARKER_DETACH_XMAT)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetCondition(s.indcon)  
	e5:SetValue(aux.imval1) 
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetCondition(s.indcon)  
	e6:SetValue(aux.tgoval)  
	c:RegisterEffect(e6)
end
s.listed_series={0x48,0x1178}

-- function s.ovfilter2(c,tp,lc)
-- 	local no=c.xyz_number
-- 	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x48,lc,SUMMON_TYPE_XYZ,tp)
-- end

-- function s.spcon(e, c)
--     if c == nil then return true end
--     local tp = c:GetControler()
--     local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
--     local g2 = g:Filter(s.ovafilter, nil, c, tp)
--     local eff={}
-- 	for tc in aux.Next(g) do
--         local no = tc.xyz_number
--         if no and no>=101 and no<=107 and tc:IsSetCard(0x48, c, SUMMON_TYPE_XYZ, tp) then
--             local e1=Effect.CreateEffect(c)
--             e1:SetType(EFFECT_TYPE_SINGLE)
--             e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
--             e1:SetCode(EFFECT_XYZ_LEVEL)
--             e1:SetValue(4)
--             e1:SetReset(RESET_CHAIN)
--             tc:RegisterEffect(e1)
--             table.insert(eff,e1)
--         end
--     end
--     local g3 = g:Filter(s.ovfilter, nil, c, tp)
-- 	for _,e1 in ipairs(eff) do
-- 		e1:Reset()
-- 	end
--     return #g2 > 2 and #g3 > 2 and Duel.GetLocationCountFromEx(c:GetControler(), tp, g3, c) > 0
-- end
-- function s.ovfilter(c, tc, tp)
--     return (not tc.xyz_filter or tc.xyz_filter(c, false, tc, tp))
-- end
-- function s.ovafilter(c, tc, tp)
--     local no = c.xyz_number
--     return no and no>=101 and no<=107 and c:IsSetCard(0x48)
-- end
-- function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
--     local c = e:GetHandler()
--     local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
--     local eff={}
-- 	for tc in aux.Next(g) do
--         local no = tc.xyz_number
--         if no and no>=101 and no<=107 and tc:IsSetCard(0x48,c,SUMMON_TYPE_XYZ,tp) then
--             local e1=Effect.CreateEffect(c)
--             e1:SetType(EFFECT_TYPE_SINGLE)
--             e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
--             e1:SetCode(EFFECT_XYZ_LEVEL)
--             e1:SetValue(4)
--             e1:SetReset(RESET_EVENT+EVENT_SPSUMMON)
--             tc:RegisterEffect(e1)
--             table.insert(eff,e1)
--         end
--     end
--     local g3 = g:Filter(s.ovfilter, nil, c, tp)
--     if #g3 <3 then return end
--     Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
--     local tg = Duel.SelectMatchingCard(tp, s.ovfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 3, 99, nil, c, tp)
--     if #tg <3 then return end
--     local ag = tg
--     local tc = tg:GetFirst()
--     while tc do
--         local ttc = tc:GetOverlayGroup()
--         if ttc ~= nil then
--             local btc = ttc:GetFirst()
--             while btc do
--                 Duel.Overlay(e:GetHandler(), btc)
--                 btc = ttc:GetNext()
--             end
--         end
--         Duel.Overlay(e:GetHandler(), tc)
--         ag:Merge(ttc)
--         tc = tg:GetNext()
--     end
--     c:SetMaterial(tg)
-- end

-- function s.atkval(e,c)
-- 	return c:GetOverlayCount()*500
-- end

function s.cnofilter(c,e,tp)
	return c.xyz_number and c.xyz_number>=101 and c.xyz_number<=107
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsSetCard(0x1048) 
end
function s.c101cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayCount()>0 and c:CheckRemoveOverlayCard(tp,c:GetOverlayCount(),REASON_COST) end
	c:RemoveOverlayCard(tp,c:GetOverlayCount(),c:GetOverlayCount(),REASON_COST)
end
function s.c101target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and Duel.IsExistingMatchingCard(s.cnofilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function s.c101operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not Duel.IsExistingMatchingCard(s.cnofilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.cnofilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g:GetFirst(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        g:GetFirst():RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        g:GetFirst():RegisterEffect(e2)
		g:GetFirst():CompleteProcedure()
		-- if Duel.IsExistingMatchingCard(s.spovfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(41546,0)) then 
		-- 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		-- 	local g2=Duel.SelectMatchingCard(tp,s.spovfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
		-- 	Duel.SendtoHand(g2,tp,REASON_EFFECT)
        --     Duel.ConfirmCards(1-tp,g2)
		-- end 
	end
end
function s.spovfilter(c,e,tp)
	  return c:IsSetCard(0x1178)
end

function s.pnofilters(c)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(0x48) and c:IsFaceup()
end
function s.indcon(e)  
	return Duel.IsExistingMatchingCard(s.pnofilters,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())  
end  